# encoding: utf-8
require 'rubygems'
require 'boxr'
require 'mechanize'


module CarrierWave
  module Storage
    class Box < Abstract
      # Stubs we must implement to create and save
      attr_reader :client_box
      # Store a single file
      def store!(file)
        @client_box = box_client
        # if @client_box
        path_folders = uploader.store_dir.split('/')
        begin
          path_temp = path_folders[0...-1].join('/')

          folder_will_up = @client_box.folder_from_path(path_temp)
          begin
            @client_box.create_folder(path_folders.last, folder_will_up)
          rescue Boxr::BoxrError => e
          end
          folder_will_up = @client_box.folder_from_path(uploader.store_dir)
          file_up = @client_box.upload_file(file.to_file, folder_will_up)
          file
        rescue  Boxr::BoxrError => e

          path_folders.each_with_index do |path, index|
            if index==0
              begin
                @client_box.create_folder("#{path}", "#{Boxr::ROOT}")
              rescue Boxr::BoxrError => e
                next
              end
            else
              begin
                parent = @client_box.folder_from_path("#{path_folders[0..index-1].join('/')}")
                @client_box.create_folder("#{path}", parent)
              rescue Boxr::BoxrError => e
                next
              end
            end
          end

          folder_will_up = @client_box.folder_from_path(uploader.store_dir)
          file_up = @client_box.upload_file(file.to_file, uploader.store_dir)
        end

        file
      end

      # Retrieve a single file
      def retrieve!(file)
        @client_box = box_client
        CarrierWave::Storage::Box::File.new(uploader, config, uploader.store_path(file), @client_box)
      end

      private
      def link_out client_id
        "https://www.box.com/api/oauth2/authorize?client_id=#{client_id}&redirect_uri=http%3A%2F%2Flocalhost&response_type=code"
      end
      def box_client
        @mechanize = Mechanize.new
        page = @mechanize.get(link_out(uploader.box_client_id))
        @mechanize.follow_meta_refresh = true
        form = page.form
        form.login = "#{uploader.box_email}"
        form.password = "#{uploader.box_password}"
        page1 = form.submit
        form1 = page1.form
        page_next = form1.submit
        code = page_next.uri.to_s.split('code=').last
        box_client = Boxr::get_tokens(code, grant_type: "authorization_code", assertion: nil, scope: nil, username: nil, client_id: uploader.box_client_id, client_secret: uploader.box_client_secret).access_token
        Boxr::Client.new(box_client)
      end
      def config
        @config ||= {}

        @config[:box_client_id] ||= uploader.box_client_id
        @config[:box_client_secret] ||= uploader.box_client_secret
        @config[:box_email] ||= uploader.box_email
        @config[:box_password] ||= uploader.box_password
        @config[:box_access_type] ||= uploader.box_access_type || "box"

        @config
      end

      class File
        include CarrierWave::Utilities::Uri
        attr_reader :path

        def initialize(uploader, config, path, client)
          @uploader, @config, @path, @client = uploader, config, path, client
        end

        def url
          file_temp = @client.file_from_path(path)
          file = @client.download_url(file_temp, version: nil)
        end

        def to_s
          url ||= ''
        end

        def delete
          file_temp = @client.file_from_path(@path)
          begin
            @client.delete_file(file_temp, if_match: nil)
          rescue Boxr::BoxrError => e
          end
        end
      end
    end
  end
end
