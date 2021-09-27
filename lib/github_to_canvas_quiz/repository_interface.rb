# frozen_string_literal: true

module GithubToCanvasQuiz
  # Interface for working with a local git repo
  class RepositoryInterface
    attr_reader :path, :git

    def initialize(path)
      path = File.expand_path(path)
      raise DirectoryNotFoundError unless Pathname(path).directory?

      @path = path
      @git = Git.init(path)
    end

    def commit_files(*filepaths, message)
      relative_paths = filepaths.map { |filepath| relative_path(filepath) }
      return unless new_repo? || relative_paths.any? { |filepath| pending_changes?(filepath) }

      git.add(relative_paths)
      git.commit("AUTO: #{message}")
    end

    private

    def relative_path(filepath)
      pathname = Pathname(filepath)
      pathname.relative? ? pathname.to_s : pathname.relative_path_from(path).to_s
    end

    def pending_changes?(filepath)
      git.status.untracked?(filepath) || git.status.changed?(filepath) || git.status.added?(filepath)
    end

    def new_repo?
      git.log.size.zero?
    rescue Git::GitExecuteError => e
      # ruby-git raises an exception when calling git.log.size on a repo with no commits
      /does not have any commits yet/.match?(e.message)
    end
  end
end
