namespace :aws do
  desc 'Copy images from one bucket to another'
  task :copy, [:source, :destination] => :environment do |t, args|
    args.with_defaults(:source => 'production', :destination => 'development')

    raise 'Production environment not allowed!' if Rails.env.production? || args.destination == 'production'

    fog = Fog::Storage.new :provider => 'AWS', :aws_access_key_id => Settings.aws.access_key_id, :aws_secret_access_key => Settings.aws.secret_access_key
    src_bucket = "#{Settings.aws.bucket_name}-#{args.source}"
    dst_bucket = "#{Settings.aws.bucket_name}-#{args.destination}"

    puts "Copying keys from \"#{src_bucket}\" to \"#{dst_bucket}\"..."

    copied = 0
    fog.directories.get(src_bucket).files.each do |file|
      key = file.key
      begin
        fog.head_object(dst_bucket, key)
        next
      rescue Exception => e
        # Key does not exist yet! Continuing...
      end

      puts "  ...copying \"#{key}\""
      fog.copy_object(src_bucket, key, dst_bucket, key, 'x-amz-acl' => 'public-read')

      copied += 1
    end

    puts "Complete! (#{copied} keys copied)"
  end
end
