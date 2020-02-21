require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dtl1
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Asia/Taipei'
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    config.hosts << ENV['ALLOW_DOMAIN']
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

module Rumors
  module Api
    module Client
      class Base
        # Monkey patch lower SIMILARITY and get more result
        # https://raw.githubusercontent.com/CarolHsu/rumors-api-client/73e47ab09dbcb011197b1c07787c360c8a46fa79/lib/rumors/api/client/base.rb
        SIMILARITY = 0.01  
        
        def calculate_similarity(contents)
          # NOTE: https://github.com/jpmckinney/tf-idf-similarity
          most_likes = []

          original_text = TfIdfSimilarity::Document.new(@text)

          corpus = [original_text]
          contents.each do |h|
            corpus << h.values.first
          end

          model = TfIdfSimilarity::TfIdfModel.new(corpus)
          matrix = model.similarity_matrix

          contents.each do |h|
            most_like = {
              article_id: '',
              score: 0
            }
            article_id, text = h.to_a.flatten
            # score = matrix[model.document_index(original_text), model.document_index(text)]
            # next unless score > most_like[:score]

            most_like[:article_id] = article_id
            # most_like[:score] = score

            most_likes << most_like
          end
          most_likes
        end        
        
        def return_article
          contents = parse_content
          return if contents.nil? || contents.empty?
          article_id = nil

          if @urls.any?
            article_id = compare_urls(contents)
          else
            most_likes = calculate_similarity(contents)
            # return unless most_like[:score] > SIMILARITY
            article_ids = most_likes.map {|most_like| most_like[:article_id]}
          end

          if article_ids.any?
            find_articles = []
            article_ids.each do |article_id|
              find_articles << find_article(article_id)
            end
            find_articles
          end
        end        
      end

      module Utils
        class ListArticles
          def initialize(text)
            @text = text
          end

          def purify_gql_query
            gql_query.strip
          end

          def variables
            { text: @text.to_s }
          end

          private

          def gql_query
            <<~GQL
            query($text: String) {
              ListArticles(
                filter: { moreLikeThis: { like: $text } }
                orderBy: [{ _score: DESC }]
                first: 4
              ) {
                edges {
                  node {
                    id
                    text
                    createdAt
                    updatedAt
                    hyperlinks {
                      url
                    }
                    articleReplies {
                      reply {
                        id
                        text
                        type
                        reference
                      }
                    }
                  }
                }
              }
            }
            GQL
          end
        end
      end      
    end
  end
end