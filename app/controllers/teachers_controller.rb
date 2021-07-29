class TeachersController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found
rescue_from ActiveRecord::RecordInvalid, with: :display_errors
rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

    before_action :authorized_admin
    before_action :find_teacher, only: [:destroy, :update]
    
    def create 
        new_teacher = @admin.teachers.create!(teacher_params)
        render json: new_teacher, serializer: AdminTeacherSerializer
    end

    def destroy
        # byebug
        default_teacher = @admin.teachers.find_by!(title: "No", last_name: "teacher")
        if default_teacher && @teacher != default_teacher
            @teacher.klasses.each {|klass| klass.update(teacher: default_teacher)}
            @teacher.destroy!
            render json: @admin.klasses
        else
            render json: {errors: "Unable to delete teacher"}
        end
    end

    def update
        @teacher.update!(teacher_params)
        render json: @teacher
    end

    private 

    def find_teacher
        @teacher = @admin.teachers.find(params[:id])
    end

    def teacher_params
        params.permit(:username, :password, :title, :first_name, :last_name, :picture_url)
    end

    def display_errors(i)
        render json: {errors: i.record.errors.full_messages}, status: :unprocessable_entity
    end

    def invalid_foreign_key
        render json: {errors: "Unable to complete this action."}, status: :unprocessable_entity
    end

    def not_found
        render json: {errors: 'Teacher not found'}, status: :not_found
    end
end
