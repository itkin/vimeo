require 'httpclient'
require 'json'

module Vimeo
  module Advanced

    class Upload < Vimeo::Advanced::Base

      def initialize(consumer_key, consumer_secret, options = {})
        super
        RestClient.add_before_execution_proc do |req, params|
          get_access_token.sign! req
        end
      end


      # Returns the space and HD uploads left for a user.
      create_api_method :get_quota,
                        "vimeo.videos.upload.getQuota"

      # Returns an upload ticket.
      create_api_method :get_ticket,
                        "vimeo.videos.upload.getTicket"

      #upload a file, for multi-upload iterate on the parts with chunck_id as counter
      def upload(end_point, file_path, ticket_id, chunk_id =0)
        RestClient.post end_point,
                        "file_data" => File.new(file_path, 'rb'),
                        "chunk_id" => chunk_id,
                        "ticket_id" => ticket_id
      end

      # Returns an upload ticket.
      create_api_method :verify_chunks,
                        "vimeo.videos.upload.verifyChunks",
                        :required => [:ticket_id]

      # Returns an upload ticket.
      create_api_method :complete ,
                        "vimeo.videos.upload.complete",
                        :required => [:ticket_id, :filename]

      # Returns an upload ticket.
      create_api_method :check_ticket,
                        "vimeo.videos.upload.checkTicket",
                        :required => [:ticket_id]

    end # Upload
  end # Advanced
end # Vimeo