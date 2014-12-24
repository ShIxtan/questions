module Savable

  def save
    columns = self.instance_variables
    id , *args = columns.map { |el| self.instance_variable_get(el) }
    insert_str = columns[1..-1].map { |sym| sym.to_s.delete('@') }.join(', ')
    update_str = columns[1..-1].map { |sym| sym.to_s.delete('@') }.join(' = ?, ')
    update_str += ' = ?'
    insert_str2 = columns[1..-1].map{ '?' }.join(', ')

    if id.nil?
      query = <<-SQL
        INSERT INTO
          #{self.class.table} (#{insert_str})
        VALUES
          (#{insert_str2})
      SQL
      execute(query, *args)
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      query = <<-SQL
        UPDATE
          #{self.class.table}
        SET
          #{update_str}
        WHERE
          id = ?
      SQL
      execute(query,*args, id)
    end
  end

  def execute(query, *args)
    QuestionsDatabase.instance.execute(query, *args)
  end
end

module Queriable
  def find_by_id id
    results = execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = ?
    SQL

    results.map { |reply| new(reply) }.last
  end

  def all
    results = execute("SELECT * FROM #{table}")
    results.map { |result| new(result) }
  end

  def execute(query, *args)
    QuestionsDatabase.instance.execute(query, *args)
  end
end
