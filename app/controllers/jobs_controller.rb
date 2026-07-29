class JobsController < ApplicationController
  def index
    @jobs = Job.includes(:persona).order(created_at: :desc).limit(50)
  end

  def new
    ensure_persona!
    @job = Job.new
  end

  def create
    persona = ensure_persona!
    return rate_limited!("2 job posts per minute. HR moves slower than that.") if persona.jobs.where(created_at: 1.minute.ago..).count >= 2

    @job = persona.jobs.new(params.require(:job).permit(:title, :company, :location, :comp, :description))
    if @job.save
      redirect_to jobs_path, notice: "Listing live. Applicants will be rejected shortly."
    else
      flash.now[:alert] = @job.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def apply
    persona = ensure_persona!
    job = Job.find(params[:id])
    application = job.job_applications.new(persona: persona)
    if application.save
      FakeNotifier.real!(job.persona, actor: persona,
        body: "#{persona.name} applied to #{job.title}. They have been rejected on your behalf.",
        url: "/jobs")
      redirect_to jobs_path(rejected: job.id), notice: application.rejection
    else
      redirect_to jobs_path, alert: application.errors.full_messages.first
    end
  end
end
