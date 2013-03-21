def get_result_income_base(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.income_base
  end
end

def get_result_employee_base(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.employee_base
  end
end

def get_result_payment(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.payment
  end
end

def get_result_after_reliefA(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.after_reliefA
  end
end

def get_result_after_reliefC(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.after_reliefC
  end
end

