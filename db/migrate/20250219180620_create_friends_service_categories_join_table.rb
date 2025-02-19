class CreateFriendsServiceCategoriesJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :friends, :service_categories do |t|
      t.index [:friend_id, :service_category_id], unique: true, name: 'index_friends_categories_on_friend_and_category'
      t.index [:service_category_id, :friend_id], name: 'index_friends_categories_on_category_and_friend'
    end
  end
end
