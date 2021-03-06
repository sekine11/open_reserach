class DiscussCommentsController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_url, alert: "新規登録もしくは、ログインしてください。"
  end

  def create
    @discussion = Discussion.find(params[:discussion_id])
    @discuss_comment = DiscussComment.new(discuss_comment_params)
    @discuss_comment.user_id = current_user.id
    @discuss_comment.discussion_id = @discussion.id
    if @discuss_comment.save
      # discussionのupdated_atを更新して更新時刻でのDESCを可能にする
      @discussion.update(updated_at: Time.now)
      @discuss_comment = DiscussComment.new
    end
  end

  def destroy
    @discussion = Discussion.find(params[:discussion_id])
    discuss_comment = DiscussComment.find(params[:id])
    discuss_comment.destroy
    @discuss_comment = DiscussComment.new
  end

  private

  def discuss_comment_params
    params.require(:discuss_comment).permit(:content)
  end
end
