class AddSubTitleToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :sub_title, :string
  end
end
