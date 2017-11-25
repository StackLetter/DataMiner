namespace :db_fix do

  task :remove_user_tag_badge_duplicates => :environment do
    counter = 0
    site = 3
    count = User.for_site(site).count

    User.for_site(site).includes(:user_badges).find_in_batches do |users|
      User.transaction do

        users.each do |user|
          grouped_by_badge = user.user_badges.group_by {|ub| [ub.badge_id]}
          grouped_by_id = user.user_badges.group_by {|ub| [ub.id]}
          grouped_by_badge.merge(grouped_by_id).values.each do |duplicates|
            duplicates.pop
            duplicates.each {|duplicate| duplicate.destroy}
          end

          grouped_by_tag = user.user_tags.group_by {|ut| [ut.tag_id]}
          grouped_by_id = user.user_tags.group_by {|ut| [ut.id]}
          grouped_by_tag.merge(grouped_by_id).values.each do |duplicates|
            duplicates.pop
            duplicates.each {|duplicate| duplicate.destroy}
          end

          counter += 1
          print("Processed #{counter} of #{count} Users... \r")
        end

      end
    end
  end

end
