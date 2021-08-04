class GradeCategoriesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :authorized_admin_or_teacher

    def update_class_grades
        # byebug
        if @admin
           @klass = @admin.klasses.find(params[:class_id])
           @klass.admin_update_grades(params[:data], params[:locked], params[:year])   
        elsif @teacher
           @klass = @teacher.klasses.find(params[:class_id])
           @klass.teacher_update_grades(params[:data], params[:year])   
        end
        grade_categories = @klass.grade_categories
        render json: grade_categories
    rescue ActiveRecord::RecordNotFound
        render json: {errors: "Class not found"}, status: :not_found
    end

    def update_student_grades
        if @admin 
           @student = @admin.students.find(params[:student_id])
        # byebug
           @student.admin_update_grades(params[:data], params[:locked], params[:year])   
        elsif @teacher
                    # byebug
           @student = @teacher.students.find(params[:student_id])
           @student.teacher_update_grades(params[:data], params[:year])   
        end
        grade_categories = @student.grade_categories
        render json: grade_categories
    rescue ActiveRecord::RecordNotFound
        render json: {errors: "Student not found"}, status: :not_found
    end

    private
    def grade_categories_params
        params.permit(:data)
    end

    # def teacher_grade_categories_params
    #     params..permit(:student_grade)
    # end
end
