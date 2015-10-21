class OCR
  attr_accessor :text

  OCR_DB = {
    [' _ ', '| |', '|_|'] => '0',
    ['   ', '  |', '  |'] => '1',
    [' _ ', ' _|', '|_ '] => '2',
    [' _ ', ' _|', ' _|'] => '3',
    ['   ', '|_|', '  |'] => '4',
    [' _ ', '|_ ', ' _|'] => '5',
    [' _ ', '|_ ', '|_|'] => '6',
    [' _ ', '  |', '  |'] => '7',
    [' _ ', '|_|', '|_|'] => '8',
    [' _ ', '|_|', ' _|'] => '9'
  }

  def initialize(text)
    @text = text
    @solution = []
  end    

  def convert
    text = @text.split("\n")
    
    row_0 = split(text[0])
    row_1 = split(text[1])
    row_2 = split(text[2])

    nr_of_digit_and_line_engine(text, row_0, row_1, row_2)
    @solution.join
  end

  def split(text)
    text.split("")
  end

  def nr_of_digit_and_line_engine(text, row_0, row_1, row_2)
    nr_of_lines = @text.split("").count {|new_lines| new_lines == "\n"}

    if row_1.length <= 3
      convert_single_digit_single_lines(text, row_0, row_1, row_2)
    elsif row_1.length > 3 && nr_of_lines == 3
      convert_multiple_digit_single_lines(text, row_0, row_1, row_2)
    elsif row_1.length > 3 && nr_of_lines > 3
      convert_multiple_digit_multiple_lines(text, row_0, row_1, row_2)
    end
  end

  def convert_single_digit_single_lines(text, row_0, row_1, row_2)
    standarize_row_length(row_0)
    standarize_row_length(row_1)
    standarize_row_length(row_2)

    row_0 = join(row_0)
    row_1 = join(row_1)
    row_2 = join(row_2)

    add_default_to_solution    
    add_matched_numbers_to_solution(row_0, row_1, row_2)    

    @solution
  end
  
  def standarize_row_length(row)
    # Equalizes row.length for last digit of line
    while row.length < 3
      row << " "
    end
    if row.length < 6 && row.length > 4
      row << " "
    end
  end

  def join(row)
    row = row.join
  end

  def add_default_to_solution
    # Default solution will be '?' if number is not matched
    @solution << "?"
  end

  def add_matched_numbers_to_solution(row_0, row_1, row_2)
    OCR_DB.each_key do |key|
      if  key[0] == row_0 && key[1] == row_1 && key[2] == row_2 
        @solution.pop
        @solution << OCR_DB[key] 
      end
    end
  end  

  def convert_multiple_digit_single_lines(text, row_0, row_1, row_2)
    while !row_2.empty?
      extract_single_digit(text, row_0, row_1, row_2)
    end
  end

  def extract_single_digit(text, row_0, row_1, row_2)
    single_digit_row_0 = []
    single_digit_row_1 = []
    single_digit_row_2 = []    

    3.times do 
      transfer_row_to_single_digit_row(row_0, single_digit_row_0)
      transfer_row_to_single_digit_row(row_1, single_digit_row_1)
      transfer_row_to_single_digit_row(row_2, single_digit_row_2)
    end    
    
    standarize_row_length(row_0)
    standarize_row_length(row_1)    
    
    single_digit_row_0 = join(single_digit_row_0)
    single_digit_row_1 = join(single_digit_row_1)
    single_digit_row_2 = join(single_digit_row_2)

    add_default_to_solution
    add_matched_numbers_to_solution(single_digit_row_0, single_digit_row_1, single_digit_row_2)
  end

  def transfer_row_to_single_digit_row(row, single_digit_row)
    single_digit_row << row[0]
    row.shift
  end

  def convert_multiple_digit_multiple_lines(text, row_0, row_1, row_2)
    nr_of_lines = (@text.count ("\n")) / 4

    convert_multiple_digit_single_lines(text, row_0, row_1, row_2)
    nr_of_lines.times do 
      @solution << ","
      4.times do 
        text.delete_at(0)
      end      
      row_0 = split(text[0])
      row_1 = split(text[1])
      row_2 = split(text[2])
      convert_multiple_digit_single_lines(text, row_0, row_1, row_2)      
    end    
  end
end