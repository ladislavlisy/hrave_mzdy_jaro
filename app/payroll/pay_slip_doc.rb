class PaySlipDoc
  def initialize(payslip_logo, payslip_text, period_desc, empl_name, empl_numb, empl_dept, empl_comp,
      column_left1, column_left2, column_right1, column_right2, row_summary)

    @payslip_logo = payslip_logo
    @payslip_text = payslip_text
    @period = period_desc
    @payslip_header1 = []
    @payslip_header1 << ['Personnel number', 'Person name', 'Period']
    @payslip_header1 << [empl_numb, empl_name, period_desc]
    @payslip_header2 = []
    @payslip_header2 << ['Department', 'Company', '']
    @payslip_header2 << [empl_dept, empl_comp, 'Payslip']

    @column_left1  = column_left1.map  {|x| [x[:title], x[:value]]}
    @column_left2  = column_left2.map  {|x| [x[:title], x[:value]]}
    @column_right1 = column_right1.map {|x| [x[:title], x[:value]]}
    @column_right2 = column_right2.map {|x| [x[:title], x[:value]]}
    @row_summary   = row_summary.map   {|x| [x[:title], x[:value]]}
  end

  def save_as(file_name)
  end
end

=begin
require 'Prawn'

class PaySlipDoc < Prawn::Document
  def initialize(payslip_logo, payslip_text, period_desc, empl_name, empl_numb, empl_dept, empl_comp,
      column_left1, column_left2, column_right1, column_right2, row_summary)

    @payslip_logo = payslip_logo
    @payslip_text = payslip_text
    @period = period_desc
    @payslip_header1 = []
    @payslip_header1 << ['Personnel number', 'Person name', 'Period']
    @payslip_header1 << [empl_numb, empl_name, period_desc]
    @payslip_header2 = []
    @payslip_header2 << ['Department', 'Company', '']
    @payslip_header2 << [empl_dept, empl_comp, 'Payslip']

    @column_left1  = column_left1.map  {|x| [x[:title], x[:value]]}
    @column_left2  = column_left2.map  {|x| [x[:title], x[:value]]}
    @column_right1 = column_right1.map {|x| [x[:title], x[:value]]}
    @column_right2 = column_right2.map {|x| [x[:title], x[:value]]}
    @row_summary   = row_summary.map   {|x| [x[:title], x[:value]]}
    super()
    
    create_stamp('approved') do
      rotate(30, :origin => [15, 15]) do
        stroke_color 'FF3333'
        stroke_ellipse [0, 0], 49, 25
        stroke_color '000000'
        fill_color '993333'
        font('Helvetica') do
          draw_text 'Approved', :at => [-23, -3]
        end
        fill_color '000000'
      end
    end
  end
  
  def draw_payslip
    font 'Helvetica', size: 8

    start_point1 = cursor

    logo_filename = "#{Rails.root}/app/assets/images/#{@payslip_logo}"
    text_filename = "#{Rails.root}/app/assets/images/#{@payslip_text}"

    image logo_filename, :position  => :right,
          :vposition => -20, :scale => 0.5
    image text_filename, :position  => :left,
          :vposition => -20, :scale => 0.1

    move_cursor_to(start_point1)

    move_down(100)

    pad(10) do
      text 'Payroll result - Payslip', :align => :center, :size => 16
    end

    header_borders_style = { :borders => [] }
    detail_borders_style = { :borders => [:bottom],
                             :border_width => 1,
                             :border_color => 'F0F0F0',
                             :border_lines => [:solid, :dotted, :solid, :dotted]}
    footer_borders_style = { :borders => [],
                             :border_width => 1,
                             :border_color => 'F0F0F0',
                             :border_lines => [:solid, :dotted, :solid, :dotted]}
    start_point2 = cursor
    table @payslip_header1,
          :row_colors => ['FFFFCC', 'FFFFFF'],
          :cell_style => header_borders_style,
          :position => :left,
          :column_widths => {0 => 100, 1 => 340, 2 => 100}  do |header|
      header.row(0).style :size => 6, :text_color => '346842'
      header.row(-1).style :size => 8, :font_style => :italic, :text_color => '000000', :padding_left => 10
    end

    table @payslip_header2,
          :row_colors => ['FFFFCC', 'FFFFFF'],
          :cell_style => header_borders_style,
          :position => :left,
          :column_widths => {0 => 100, 1 => 340, 2 => 100}  do |header|
      header.row(0).style :size => 6, :text_color => '346842'
      header.row(-1).style :size => 8, :font_style => :italic, :text_color => '000000', :padding_left => 10
    end

    table_point1 = cursor
    table @column_left1,
          #:row_colors => ['FFFFFF', 'FFFFCC'],
          :cell_style => detail_borders_style,
          :position => :left,
          :column_widths => {0 => 170, 1 => 100} do |detail|
      detail.column(0).style :text_color => '346842'
      detail.column(-1).style :align => :right, :font_style => :bold, :text_color => '1B1B3B', :padding_right => 10
    end
    left_table_point2 = cursor
    table @column_left2,
          #:row_colors => ['FFFFFF', 'FFFFCC'],
          :cell_style => detail_borders_style,
          :position => :left,
          :column_widths => {0 => 170, 1 => 100} do |detail|
      detail.column(0).style :text_color => '346842'
      detail.column(-1).style :align => :right, :font_style => :bold, :text_color => '1B1B3B', :padding_right => 10
    end
    left_table_point3 = cursor

    move_cursor_to(table_point1)
    table @column_right1,
          #:row_colors => ['FFFFFF', 'FFFFCC'],
          :cell_style => detail_borders_style,
          :position => :right,
          :column_widths => {0 => 170, 1 => 100}  do |detail|
      detail.column(0).style :text_color => '346842'
      detail.column(-1).style :align => :right, :font_style => :bold, :text_color => '1B1B3B', :padding_right => 10
    end
    right_table_point2 = cursor
    table @column_right2,
          #:row_colors => ['FFFFFF', 'FFFFCC'],
          :cell_style => detail_borders_style,
          :position => :right,
          :column_widths => {0 => 170, 1 => 100} do |detail|
      detail.column(0).style :text_color => '346842'
      detail.column(-1).style :align => :right, :font_style => :bold, :text_color => '1B1B3B', :padding_right => 10
    end
    right_table_point3 = cursor
    move_cursor_to([left_table_point3, right_table_point3].min)
    table [@row_summary.flatten],
          :row_colors => ['FFFFCC', 'FFFFCC'],
          :cell_style => footer_borders_style,
          :position => :left,
          :column_widths => {0 => 170, 1 => 100, 2 => 170, 3 => 100} do |detail|
      detail.column(1).style :align => :right, :font_style => :bold, :text_color => '346842', :padding_right => 10
      detail.column(3).style :align => :right, :font_style => :bold, :text_color => '346842', :padding_right => 10
    end
    ended_point1 = cursor

    stamp_at 'approved', [450, 150]

    stroke do
      rounded_rectangle [0, start_point2], 540, start_point2-ended_point1, 10
    end

    move_cursor_to(10)
    text 'www.hravemzdy.cz', :align => :left, :size => 6, :font_style => 'italic'
  end

  def save_as(file_name)
    draw_payslip
    render_file(file_name)
  end
end
=end
