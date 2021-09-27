# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::RepositoryInterface do
  def create_repo_files!(path)
    File.write(File.join(path, 'temp1.txt'), '123')
    File.write(File.join(path, 'temp2.txt'), '123')
    File.write(File.join(path, 'temp3.txt'), '123')
  end

  describe '#initialize' do
    it 'initializes git if given a directory that is not a repo' do
      in_temp_dir do |path|
        repo = described_class.new(path)

        expect(repo.git).to be_a(Git::Base)
      end
    end

    it 'loads git if given a directory that is a repo' do
      in_temp_dir do |path|
        Git.init(path)

        repo = described_class.new(path)

        expect(repo.git).to be_a(Git::Base)
      end
    end

    it 'raises an error if given a path that does not exist' do
      in_temp_dir do |path|
        bad_path = File.join(path, '/nothing-here')

        expect { described_class.new(bad_path) }.to raise_error(GithubToCanvasQuiz::DirectoryNotFoundError)
      end
    end
  end

  describe '#commit_files' do
    it 'commits untracked files when given a relative path' do
      in_temp_dir do |path|
        create_repo_files!(path)
        git = Git.init(path)
        git.add('temp1.txt')
        git.commit('Initial commit')

        files = ['temp2.txt', 'temp3.txt']

        repo = described_class.new(path)
        repo.commit_files(*files, 'commit message')

        any_untracked = files.any? { |file| git.status.untracked?(file) }
        expect(any_untracked).to eq(false)
      end
    end

    it 'commits untracked files when given a full path' do
      in_temp_dir do |path|
        create_repo_files!(path)
        git = Git.init(path)
        git.add('temp1.txt')
        git.commit('Initial commit')

        files = ['temp2.txt', 'temp3.txt'].map { |file| File.join(path, file) }

        repo = described_class.new(path)
        repo.commit_files(*files, 'commit message')

        any_untracked = files.any? { |file| git.status.untracked?(file) }
        expect(any_untracked).to eq(false)
      end
    end

    it 'makes a commit message' do
      in_temp_dir do |path|
        create_repo_files!(path)
        git = Git.init(path)
        git.add('temp1.txt')
        git.commit('Initial commit')

        repo = described_class.new(path)
        repo.commit_files('temp2.txt', 'commit message')

        expect(git.log.first.message).to eq('AUTO: commit message')
      end
    end

    it 'does not make a new commit when a file with no changes' do
      in_temp_dir do |path|
        create_repo_files!(path)

        git = Git.init(path)
        git.add('temp1.txt')
        git.commit('Initial commit')
        log_size = git.log.size

        repo = described_class.new(path)
        repo.commit_files('temp1.txt', 'commit message')

        expect(git.log.size).to eq(log_size)
      end
    end
  end
end
