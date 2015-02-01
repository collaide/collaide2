include Faker if Rails.env == 'development'
namespace :populate do
  desc 'Populate Database with fake datas'
  task all: %w(environment db:dev_only) do
    u = User.find_or_create_by! email: 'q@qwe.as' do |u|
      u.name = Name.name
      u.password = 'grimpe'
      u.password_confirmation = 'grimpe'
    end
    group = Group::Group.find_or_create_by!(name: Lorem.word) do |g|
      g.user = u
    end
    100.times do
      if rand(0..1) == 1
        title = Lorem.sentence
      else
        title = nil
      end
      group.topics << Group::Topic.create!(title: title, message: message, user: u, group: group)
    end
    group.topics.each do |topic|
      1000.times do
        topic.comments << Group::Comment.create!(message: message, user: u, topic: topic)
      end
    end
    puts "Created 100 topics with 1000 comments each for #{group.name} owned by #{u.name} (#{u.email} password: grimpe)"
  end
end

def message
  Lorem.paragraphs(rand(1..10)).map {|p| "<p>#{p}</p>"}.join('')
end