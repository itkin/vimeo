require 'httpclient'
require 'json'

module Vimeo
  module Advanced

    class Upload < Vimeo::Advanced::Base

      # TODO: Make this work with either a JSON or an XML manifest.
#      # Confirms the upload process.
#      create_api_method :confirm,
#                        "vimeo.videos.upload.confirm",
#                        :required => [:ticket_id]
#
      # "{\"files\":[{\"md5\":\"731f09145a1ea9ec9dad689de6fa0358\"}]}"

      # Returns the space and HD uploads left for a user.
      create_api_method :get_quota,
                        "vimeo.videos.upload.getQuota"

      # Returns an upload ticket.
      create_api_method :get_ticket,
                        "vimeo.videos.upload.getTicket"

      # Upload +file+ to vimeo with +ticket_id+ and +auth_token+
      # Returns the json manifest necessary to confirm the upload.
#      def upload(auth_token, file_path, ticket_id, end_point)
#        params = {
#          :auth_token => auth_token,
#          :ticket_id  => ticket_id
#        }
#        params[:api_sig] = generate_api_sig params
#
#        params.merge!({ :file_data => File.open(file_path) })
#
#        client = HTTPClient.new
#        response = client.post(end_point, params)
#        md5 = response.content
#
#        self.class.create_json_manifest(md5)
#      end

      #upload a file, for multi-upload iterate with chunk_id as counter
      def upload(end_point, file_path, ticket_id, chunk_id =0)

        
#        get_access_token.post(end_point, {"file_data" => File.new(file_path, 'rb'), "chunk_id" => chunk_id, "ticket_id" => ticket_id}, {'Content-Type' => 'multipart/form-data'})

        RestClient.add_before_execution_proc do |req, params|
          get_access_token.sign! req
        end


        RestClient.post end_point,
                        "file_data" => File.new(file_path, 'rb'),
                        "chunk_id" => chunk_id,
                        "ticket_id" => ticket_id


#        url = URI.parse(end_point)
#        req = Net::HTTP::Post::Multipart.new url.path,"file_data" => UploadIO.new(file_path, "application/octet-stream"),          "chunk_id" => chunk_id,          "ticket_id" => ticket_id
#        @oauth_consumer.sign!(req, get_access_token)
#        debugger
#        res = Net::HTTP.start(url.host, url.port) do |http|
#          http.request(req)
#        end
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


      # TODO: Make this work with either json or xml manifest.
      # FIXME: Ticket id is required?
#      # Verifies a file manifest.
#      create_api_method :verify_manifest,
#                        "vimeo.videos.upload.verifyManifest",
#                        :required => [:auth_token, :ticket_id]
#
#      # TODO: Make this more flexible for split uploads?
#      def self.create_json_manifest(md5s)
#        { :files => md5s.map { |md5| { :md5 => md5 } } }.to_json
#      end

    end # Upload
  end # Advanced
end # Vimeo