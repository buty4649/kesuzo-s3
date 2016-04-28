require 'thor'
require 'aws-sdk'
require 'readline'

module KesuzoS3
  class CLI < Thor
    desc "version", "show version"
    def version
      puts "v#{KesuzoS3::VERSION}"
    end

    desc "count <bucket>", "count objects"
    def count(bucket)
      Aws.config[:region] = 'ap-northeast-1'
      s3 = Aws::S3::Client.new

      count = s3.list_objects(bucket: bucket).inject(0) {|sum, response|
        print "."
        sum += response.contents.length
      }
      puts
      puts count
    end

    desc "exec <bucket>", "bucket kesu"
    def exec(bucket)
      exit if Readline.readline("OK?[y/N] ") != "y"
      exit if Readline.readline("Really?[y/N] ") != "y"

      Aws.config[:region] = 'ap-northeast-1'
      s3 = Aws::S3::Client.new

      progress = 0
      s3.list_objects(bucket: bucket).each do |response|
        r = s3.delete_objects({
          bucket: bucket,
          delete: {objects: response.contents.map{|k| {key: k.key}}}
        })
        progress += r.deleted.length
        puts "#{progress} deleted..."

        delete_retry = 0
        while r.errors.length > 0 && delete_retry < 3
          delete_retry += 1

          r = s3.delete_objects({
            bucket: bucket,
            delete: {objects: r.errors.map{|k| {key: k.key}}}
          })
          progress += r.deleted.length
          puts "#{progress} deleted..."
        end

        if r.errors.length > 0
          puts "Delete Failed..."
          r.errors.each {|o| puts "-> #{o.key}"}
        end
      end

      puts "Delete bucket."
      s3.delete_bucket(bucket: bucket)
    end
  end
end
