class Article < ApplicationRecord
  scope :full_text_search, -> (query, highlight = false) {
    operator = query.count('"') > 0 || extract_keywords(query).size > 1 ? '@@' : '%%'
    quoted_table_name = connection.quote_table_name(table_name)
    articles = select("#{quoted_table_name}.*, pgroonga.score(#{quoted_table_name}) AS pgroonga_score")
               .where("title #{operator} ? OR body #{operator} ?", query, query)
               .reorder('pgroonga_score DESC')

    return articles unless highlight

    quoted_query = connection.quote(query)
    articles.select(<<-COLUMNS.strip_heredoc)
      pgroonga.highlight_html(title, pgroonga.query_extract_keywords(#{quoted_query})) AS highlighted_title,
      pgroonga.highlight_html(body, pgroonga.query_extract_keywords(#{quoted_query})) AS highlighted_body
    COLUMNS
  }

  def self.extract_keywords(query)
    quoted_query = connection.quote(query)
    connection.select_values("SELECT unnest(pgroonga.query_extract_keywords(#{quoted_query}))")
  end

  def highlighted_attribute(name)
    highlighted_name = "highlighted_#{name}"
    has_attribute?(highlighted_name) ? send(highlighted_name).to_s.html_safe : send(name)
  end
end
