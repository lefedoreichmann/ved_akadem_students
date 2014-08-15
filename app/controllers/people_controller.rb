class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :show_photo]
  before_action :authenticate_person!

  after_filter :verify_authorized
  after_filter :verify_policy_scoped, except: [:new, :create]

  def new
    @person = Person.new

    authorize @person
  end

  def create
    @person = Person.new(PersonParams.filter(params).merge(skip_password_validation: true))

    authorize @person

    if @person.save
      flash[:success] = "#{view_context.link_to( view_context.complex_name(@person), person_path(@person) )} added.".html_safe

      redirect_to action: :new
    elsif
      render      action: :new
    end
  end

  def show
    authorize @person
  end

  def edit
    authorize @person
  end

  def index
    @people = policy_scope(Person)

    authorize Person
  end

  def destroy
    authorize @person

    if @person.destroy.destroyed?
      redirect_to people_path , flash: { success: 'Person record deleted!'  }
    else
      redirect_to :back       , flash: { error:   'Person deletion failed!' }
    end
  end

  def update
    authorize @person

    if @person.update_attributes(PersonParams.filter(params).merge(skip_password_validation: true))
      redirect_to @person, flash: { success: 'Person was successfully updated.' }
    else
      render      action: :edit
    end
  end

  def show_photo
    authorize @person

    path = if params[:version] == 'default'
             @person.photo_url
           else
             @person.photo.versions[params[:version].to_sym].url
           end

    send_file( path,
               disposition: 'inline',
               type: 'image/jpeg',
               x_sendfile: true )
  end

  class PersonParams
    def self.filter params
      params.require(:person).permit(
        :name           ,
        :spiritual_name ,
        :middle_name    ,
        :surname        ,
        :email          ,
        :telephone      ,
        :gender         ,
        :birthday       ,
        :edu_and_work   ,
        :emergency_contact
      )
    end
  end

  private

  def set_person
    @person = policy_scope(Person).find(params[:id])
  end
end
