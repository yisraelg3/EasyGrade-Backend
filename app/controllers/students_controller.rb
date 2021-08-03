class StudentsController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :display_errors
rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :authorized_admin, only: [:create, :destroy, :update]
    before_action :find_student, only: [:destroy, :update]

    def create
        # byebug
        params[:parent_id] = @admin.parents.first.id unless params[:parent_id] > 0
        parent = @admin.parents.find(params[:parent_id])

        new_student = parent.students.create!(student_params)
        new_student.create_grade_categories_from_array(params[:currentClasses], params[:year])

        new_grade_categories = new_student.grade_categories
        render json: {student: StudentSerializer.new(new_student),
             grade_categories: ActiveModel::Serializer::CollectionSerializer.new(new_grade_categories, each_serializer: GradeCategorySerializer)}
    rescue ActiveRecord::RecordNotFound
        render json: {errors: "Parent not found"}, status: :not_found
    end

    def destroy
        @student.destroy
        render json: @student
    end

    def update
        # byebug
        @student.update(student_params)

        to_destroy = @student.grade_categories.pluck(:klass_id)-params[:currentClasses]
        to_create = params[:currentClasses]-@student.grade_categories.pluck(:klass_id)

        @student.destroy_grade_categories_from_array(to_destroy, params[:year])
        @student.create_grade_categories_from_array(to_create, params[:year])

        updated_grade_categories = @student.grade_categories
        render json: {student: StudentSerializer.new(@student), 
        grade_categories: ActiveModel::Serializer::CollectionSerializer.new(updated_grade_categories, each_serializer: GradeCategorySerializer)}
    end

    private
    def find_student
        @student = @admin.students.find(params[:id])
    end

    def student_params
        params.permit(:parent_id, :first_name, :last_name, :birth_date, :picture_url)
    end

    def display_errors(i)
        render json: {errors: i.record.errors.full_messages}
    end

    def not_found
        render json: {errors: "Student not found"}
    end
end
