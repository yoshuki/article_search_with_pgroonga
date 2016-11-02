module DisableSequentialScan
  def exec_queries
    @klass.connection.exec_query('SET enable_seqscan TO off')
    super
  ensure
    @klass.connection.exec_query('SET enable_seqscan TO on')
  end
end
