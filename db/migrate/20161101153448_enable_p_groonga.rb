class EnablePGroonga < ActiveRecord::Migration[5.0]
  def change
    reversible do |r|
      current_database = select_value('SELECT current_database()')

      r.up do
        enable_extension('pgroonga')
        execute("ALTER DATABASE #{current_database} SET search_path = '$user',public,pgroonga,pg_catalog;")
      end

      r.down do
        execute("ALTER DATABASE #{current_database} RESET search_path;")
        disable_extension('pgroonga')
      end
    end
  end
end
