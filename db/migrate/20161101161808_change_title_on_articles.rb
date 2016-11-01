class ChangeTitleOnArticles < ActiveRecord::Migration[5.0]
  def up
    change_column :articles, :title, :text
  end

  def down
    change_column :articles, :title, :string
  end
end
