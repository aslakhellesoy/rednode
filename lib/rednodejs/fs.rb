module Rednodejs
  class Fs
    def Stats
      lambda do
      end
    end

    # TODO: Shouldn't we receive something for the anonymus "handler" function?
    # See fs.js:601:
    # fs.open(this.path, this.flags, this.mode, function(err, fd) {
    def open(path, flags, mode)
    end

    def read
      lambda do
      end
    end

    def close
      lambda do
      end
    end
  end
end