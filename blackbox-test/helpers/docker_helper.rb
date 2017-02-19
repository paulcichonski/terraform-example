module DockerHelper
  class << self

    ## hardcoded to assume:
    ## - a mount for /opt/project exists
    ## - the variable file is at `/opt/project/dev-env/configs/terraform.tfvars`
    def get_tfvars_path
      this_cid = `hostname`
      raise "ERROR: could not find container id, err:\n #{this_cid}" if $? != 0

      out = %x(docker inspect -f '{{range .Mounts}}{{if eq .Destination "/opt/project"}}{{.Source}}{{end}}{{end}}' #{this_cid})
      raise "ERROR: could not find host path for /opt/project, err:\n #{out}" if $? != 0
      File.join(out.strip, "dev-env/configs/terraform.tfvars")
    end
  end
end
