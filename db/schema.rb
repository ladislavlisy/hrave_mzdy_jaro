# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130126105057) do

  create_table "payroll_periods", :id => false, :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payroll_tasks", :force => true do |t|
    t.integer  "period_code"
    t.string   "description"
    t.datetime "task_start"
    t.datetime "task_end"
    t.string   "company_name"
    t.string   "payrolee_name"
    t.string   "payrolee_mail"
    t.string   "employee_name"
    t.string   "employer_name"
    t.string   "employee_numb"
    t.string   "department"
    t.integer  "empl_salary"
    t.boolean  "tax_declare"
    t.boolean  "tax_payer"
    t.boolean  "tax_study"
    t.boolean  "tax_disab1"
    t.boolean  "tax_disab2"
    t.boolean  "tax_disab3"
    t.boolean  "tax_child1"
    t.boolean  "tax_child2"
    t.boolean  "tax_child3"
    t.boolean  "tax_child4"
    t.boolean  "tax_child5"
    t.boolean  "ins_health"
    t.boolean  "ins_social"
    t.boolean  "min_health"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
