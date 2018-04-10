# credit: code from https://github.com/xerions/exradius/

alias Radius.Attributes
require Radius.Attributes

:application.load(:eradius)
path = :code.priv_dir(:eradius) |> Path.join("dictionaries")
files = File.ls!(path)

for file <- files do
  Attributes.mk_dict(path, file) |> Code.compile_quoted(file)
end
