require 'deploy/repository'

module Docker
  class Repository < ::Deploy::Repository
    private

    def version!
      super
      data_hash = JSON.parse(File.read('Dockerrun.aws.json'))
      a = data_hash['Image']['Name']
      b = a.sub(/:.*/, '')
      c = "#{b}:#{@tag}"
      data_hash['Image']['Name'] = c
      d = JSON.pretty_generate(data_hash)
      File.open('Dockerrun.aws.json', 'w') do |f|
        f.write d
      end
    end

    def commit!
      puts 'Committing version.txt and Dockerrun.aws.json...'
      unless system('git add public/version.txt Dockerrun.aws.json') && system("git commit -m \"#{commit_message}\" ")
        fail 'Failed to commit.'
      end
    end
  end
end