module Rednodejs
  autoload :BindingModule,  'rednodejs/binding_module'
  autoload :Buffer,  'rednodejs/buffer'
  autoload :Crypto,  'rednodejs/crypto'
  autoload :Exports, 'rednodejs/exports'
  autoload :Fs,      'rednodejs/fs'
  autoload :Natives, 'rednodejs/natives'
  autoload :Net,     'rednodejs/net'
  autoload :Process, 'rednodejs/process'
  autoload :Cares,   'rednodejs/cares'
  autoload :Stdio,   'rednodejs/stdio'
end

require 'rednodejs/context'