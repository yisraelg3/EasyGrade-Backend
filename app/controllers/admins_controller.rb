class AdminsController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :display_errors
rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :authorized, only: [:me]
    def create
        new_admin = Admin.create!(admin_params)
        new_admin.create_default
        token = encode_token({user_id: new_admin.id, class: "Admin"})
        render json: {user: AdminSerializer.new(new_admin), token: token}
    end

    def index
        render json: @admin
    end

    def login
        # byebug
        admin = Admin.find_by(username: params[:username])
        if admin && admin.authenticate(params[:password])
            wristband = encode_token({user_id: admin.id, class: 'Admin'})
            render json: {user: AdminSerializer.new(admin), token: wristband}
        else
            render json: {errors: "wrong username or password"}
        end
    end

    def me
        # byebug
        # wristband = encode_token({user_id: @user.id, class: decoded_token[0]['class']})
        # appropiate_serializer = (decoded_token[0]['class']+'Serializer').constantize
        #     render json: {user: appropiate_serializer.new(@user), token: wristband}

        if decoded_token[0]['class'] == 'Admin'
            wristband = encode_token({user_id: @admin.id, class: 'Admin'})
            render json: {user: AdminSerializer.new(@admin), token: wristband}
        elsif decoded_token[0]['class'] == 'Teacher'
            wristband = encode_token({user_id: @teacher.id, class: 'Teacher'})
            render json: {user: TeacherSerializer.new(@teacher), 
            grade_categories: ActiveModel::Serializer::CollectionSerializer.new(GradeCategory.all, each_serializer: GradeCategorySerializer), token: wristband}
        elsif decoded_token[0]['class'] == 'Parent'
            wristband = encode_token({user_id: @parent.id, class: 'Parent'})
            render json: {user: ParentSerializer.new(@parent), token: wristband}
        end
    end

    private
    def admin_params
        params.permit(:username, :password, :title, :first_name, :last_name)
    end

    def display_errors(i)
        render json: {errors: i.record.errors.full_messages}, status: :unprocessable_entity
    end

    def not_found
        render json: {errors: 'Admin user not found'}, status: :not_found
    end
end
