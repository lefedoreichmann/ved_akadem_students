require 'spec_helper'

describe Person do
  COLUMNS = {
    name:               :string   ,
    middle_name:        :string   ,
    surname:            :string   ,
    spiritual_name:     :string   ,
    telephone:          :integer  ,
    email:              :string   ,
    gender:             :boolean  ,
    birthday:           :date     ,
    emergency_contact:  :string   ,
    edu_and_work:       :text
  }

  COLUMNS.each do |name, type|
    context ":" do 
      let(:name) { name }
      let(:type) { type }
      it_should_behave_like "have DB column of type"
    end
  end
end
