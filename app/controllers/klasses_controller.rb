class KlassesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found
rescue_from ActiveRecord::RecordInvalid, with: :display_errors
rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
   
    before_action :authorized_admin, only: [:create, :destroy, :update]
    before_action :find_klass, only: [:destroy, :update]

    def create
        # byebug
        params[:teacher_id] = @admin.teachers.first.id unless params[:teacher_id].to_i > 0
        teacher = @admin.teachers.find(params[:teacher_id])
        new_class = teacher.klasses.create!(class_params)
        new_class.create_grade_categories_from_array(params[:currentStudents])
        new_grade_categories = new_class.grade_categories
        # new_grade_categories = new_class.create_grade_categories_for_new_klass(params[:grade_categories])
        # byebug
        render json: {klass: KlassSerializer.new(new_class), 
            grade_categories: ActiveModel::Serializer::CollectionSerializer.new(new_grade_categories, each_serializer: GradeCategorySerializer)}
    rescue ActiveRecord::RecordNotFound
        render json: {errors: "Teacher not found"}, status: :not_found
    end

    def destroy
        # byebug
        # default_klass = @admin.klasses.find_by!(grade: "No ", subject: "class")
        # if default_klass && @klass != default_klass
        #     @klass.students.each do |student| 
        #         # byebug
        #         student.grade_categories.first.update(klass: default_klass) #does't work need to check why!!! -> unless @admin.students.pluck(:id).include?(student.grade_categories.first.student_id) <-
        #     end
            @klass.destroy!
            render json: @klass
        # else
        #     render json: {errors: "Unable to delete a class if it still has students assigned to it"}
        # end
    end

    def update
        # byebug
        @klass.update(class_params)

        to_destroy = @klass.grade_categories.pluck(:student_id)-params[:currentStudents]
        to_create = params[:currentStudents]-@klass.grade_categories.pluck(:student_id)

        @klass.destroy_grade_categories_from_array(to_destroy)
        @klass.create_grade_categories_from_array(to_create)

        updated_grade_categories = @klass.grade_categories
        render json: {klass: KlassSerializer.new(@klass), 
        grade_categories: ActiveModel::Serializer::CollectionSerializer.new(updated_grade_categories, each_serializer: GradeCategorySerializer)}
    end

    private
    def find_klass
        @klass = @admin.klasses.find(params[:id])    
    end

    def class_params
        params.permit(:teacher_id, :grade, :subject, :locked)
    end

    def display_errors(i)
        render json: {errors: i.record.errors.full_messages}, status: :unprocessable_entity
    end

    def invalid_foreign_key
        render json: {errors: "Unable to complete this action."}, status: :unprocessable_entity
    end

    def not_found
        render json: {errors: 'Class not found'}, status: :not_found
    end
end
