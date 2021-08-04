class ParentsController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :display_errors
rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :authorized_admin, only: [:create, :update, :destroy]
    before_action :find_parent, only: [:update, :destroy]

    def create
        new_parent = @admin.parents.create!(parent_params)
        students_to_assign = Student.all.where(id:[params[:currentStudents]]) 
        students_to_assign.update_all(parent_id: new_parent.id)
        students = new_parent.students
        # byebug
        render json: {parent: AdminParentSerializer.new(new_parent),
            students: ActiveModel::Serializer::CollectionSerializer.new(students, each_serializer: StudentSerializer)}
    end

    def update
        @parent.update(parent_params)

        default_parent = @admin.parents.first
        @parent.students.where.not(id: params[:currentStudents]).update(parent_id: default_parent.id)
        Student.where(id: params[:currentStudents]).update(parent_id: @parent.id)

        students = @parent.students
        # byebug
        render json: {parent: AdminParentSerializer.new(@parent),
            students: ActiveModel::Serializer::CollectionSerializer.new(students, each_serializer: StudentSerializer)}
    end

    def destroy
        default_parent = @admin.parents.first
        @parent.students.update_all(parent_id: default_parent.id)
        # byebug
        if default_parent && @parent != default_parent
            @parent.destroy!
            render json: @parent
        else
            render json: {errors: "Unable to delete parent"}
        end
    end

    def login
        # byebug
        parent = Parent.find_by(username: params[:username])
        if parent && parent.authenticate(params[:password])
            wristband = encode_token({user_id: parent.id, class: 'Parent'})
            render json: {user: ParentSerializer.new(parent), token: wristband}
        else
            render json: {errors: "wrong username or password"}
        end
    end

    private
    def find_parent
        @parent = @admin.parents.find(params[:id])
    end

    def parent_params
        params.permit(:username, :password)
    end

    def display_errors(i)
        render json: {errors: i.record.errors.full_messages}, status: :unprocessable_entity
    end

    def not_found
        render json: {errors: "Student not found"}
    end
end
