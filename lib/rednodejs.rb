module Rednodejs
  autoload :Buffer,  'rednodejs/buffer'
  autoload :Exports, 'rednodejs/exports'
  autoload :Fs,      'rednodejs/fs'
  autoload :Natives, 'rednodejs/natives'
  autoload :Process, 'rednodejs/process'
end

require 'rednodejs/context'