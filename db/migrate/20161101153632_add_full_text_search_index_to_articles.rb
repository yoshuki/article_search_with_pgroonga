class AddFullTextSearchIndexToArticles < ActiveRecord::Migration[5.0]
  def change
    add_index :articles, [:id, :title, :body], using: 'pgroonga'
  end
end
