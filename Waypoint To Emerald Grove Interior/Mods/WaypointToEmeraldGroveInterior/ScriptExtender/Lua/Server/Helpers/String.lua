String = {}

function LevenshteinDistance(str1, str2)
  local len1 = string.len(str1)
  local len2 = string.len(str2)
  local matrix = {}
  local cost = 0

  -- Initialize the matrix
  for i = 0, len1, 1 do
    matrix[i] = { [0] = i }
  end
  for j = 0, len2, 1 do
    matrix[0][j] = j
  end

  -- Calculate distances
  for i = 1, len1, 1 do
    for j = 1, len2, 1 do
      if string.byte(str1, i) == string.byte(str2, j) then
        cost = 0
      else
        cost = 1
      end

      matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
    end
  end

  return matrix[len1][len2]
end

function String.FindClosestMatch(user_input, valid_options)
  local min_distance = math.huge -- Represents infinity
  local closest_match = nil
  for _, option in ipairs(valid_options) do
    local distance = LevenshteinDistance(user_input, option)
    if distance < min_distance then
      min_distance = distance
      closest_match = option
    end
  end
  return closest_match, min_distance
end

return String
