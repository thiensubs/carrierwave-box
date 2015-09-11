# Carrierwave::Box

Now you can use box.net/box.com with Carrierwave.

Easy to config, easy use, and helpful.

You can use box.net/box.com to store image (i was check, it working with rails to show image in view).

Gem will auto generater access token, don't worry about access token. :D

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-box'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-box
##Note:

  In your developer web view, you need to set return uri to: http://localhost

## Usage

So simple:

- Config for carrierwave:

  ```ruby

      CarrierWave.configure do |config|
        config.box_client_id = 'your_client_id'
        config.box_client_secret = 'your_secret_id'
        config.box_email = 'your_box_email'
        config.box_password = 'your_box_password'
        config.box_access_type = "box"
        config.cache_dir = "#{Rails.root}/tmp/uploads"
        config.enable_processing = true
      end
  ```

Special of this gem:

    - Gem will auto generater access token.

    - No need time to get access token.

    - Why box.net/box.com is so difficult to do gem: Access token is only valid in 60 minutes. :(

    - With gem you can easy to use, but notice time to upload will be longer. (it depend your internet and your vps/computer).

- How to integate:

  ```ruby
    class FileUpload < ActiveRecord::Base
      # Upload picture
      mount_uploader :file_name, AbcUploader
    end
  ```

  ```ruby
    class AbcUploader < CarrierWave::Uploader::Base
      # Include RMagick or MiniMagick support:
      # include CarrierWave::RMagick
      # include CarrierWave::MiniMagick
      # Choose what kind of storage to use for this uploader:
      storage :box
    end
  ```

- To show image in view with Rails

  EX:

  = image_tag FileUpload.last.file_name.url

## TODO

  - Test, test and test...

  - Improvement speed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thiensubs/carrierwave-box. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License
Copyright (c) 2015 thiensubs - Vo Tien An
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

