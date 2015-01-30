module GitWakaTime
  class Commit
    attr_accessor :sha, :date, :message, :files, :time_in_seconds, :git, :author

    def initialize(git, commit, load_files = true)
      @raw_commit      = commit
      @sha             = @raw_commit.sha
      @date            = @raw_commit.date
      @message         = @raw_commit.message
      @author          = @raw_commit.author
      @time_in_seconds = 0
      @git             = git
      @load_files      = load_files
      @files = load  if load_files
    end

    def to_s
      format('%-8s %8s %-30s %-80s'.green,
             sha[0..8],
             date,
             ChronicDuration.output(time_in_seconds),
             message
             )
    end

    private

    def load
      # TODO: Assume gap time to lookup time prior to first commit.
      return [] unless @raw_commit.parent
      @raw_commit.diff_parent.stats[:files].keys.map do |file|
        CommitedFile.new(git: @git, commit: @raw_commit, name: file, dependent: false)
      end
    end
  end
end
