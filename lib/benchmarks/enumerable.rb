module Enumerable
  # Map but don't collect `nil` result values.
  def compact_map
    each_with_object([]) { |item, acc|
      result = yield(item)
      acc << result if result
    }
  end

  # Map but don't collect duplicate result values.
  def uniq_map
    each_with_object([]) { |item, acc|
      result = yield(item)
      acc << result if acc.exclude?(result)
    }
  end
end
