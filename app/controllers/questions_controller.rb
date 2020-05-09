class QuestionsController < ApplicationController

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @ques_comment = QuesComment.new
  end

  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag]).order(created_at: "DESC").page(params[:page]).per(20)
    else
      @questions = Question.all.order(created_at: "DESC").page(params[:page]).per(20)
    end
    @rank_questions = Question.all.order(created_at: "DESC")
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      redirect_to @question, notice: "質問を投稿しました"
    else
      @question = Question.new
      render "new"
    end
  end

  def update
  	if params[:status]
  		@question = Question.find(params[:id])
	    if @question.update(status: params[:status])
	      redirect_to @question, notice: "質問を「解決済み」にしました"
	    else
	      render "edit"
	    end
  	else
	    @question = Question.find(params[:id])
	    if @question.update(question_params)
	      redirect_to @question, notice: "質問を編集しました"
	    else
	      render "edit"
	    end
	end
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to questions_path
  end

  private
  def question_params
    params.require(:question).permit(:subject, :content, :status, :tags, question_list: [])
  end

end
