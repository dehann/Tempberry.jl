# file dedicated to data logging funtions

function removeoldlogs(dir, days)
  today = Dates.today()
  # https://docs.julialang.org/en/stable/stdlib/file/
  for (root, dirs, files) in walkdir(dir)
    for file in files
      sfn = split(split(file, '.')[1],'-')
      filedate = parse.(Int, sfn) # convert filename to integers for date
      ndays = today - Date(filedate...) # splat
      if Dates.value(ndays) > days
        # remove the file
        Base.Filesystem.rm(joinpath(dir, file))
      end
    end
  end
  nothing
end

function logging(stl::Dict; dir="$(ENV["HOME"])/temperaturelogs/", days=30 )
  # check if the logging directory exists
  isdir(dir) ? nothing : mkdir(dir)  # compact if statement
  # check if there are old logs which should be removeoldlogs
  removeoldlogs(dir, days)
  # get current timestamp
  nw = now()
  # for formatting see https://stackoverflow.com/questions/37253537/print-current-time-in-julia
  # build new data string
  str = Dates.format(nw, "HH:MM:SS")
  for i in 1:stl[:numtherms]
    thermsym = Symbol("temp$(i)")
    str *= ", $(stl[thermsym])"
  end

  # open the file and append new data
  filename = Dates.format(nw, "yyyy-mm-dd")
  filename *= ".csv"
  fid = open(joinpath(dir,filename), "a") # append mode
  println(fid, str)
  close(fid)

  nothing
end
