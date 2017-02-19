require 'json'

module TerraformHelper
  class << self

    def destroy
      @outputs = nil
      run "destroy", progress: true
    end

    def apply
      run "apply", progress: true
    end

    def outputs
      @outputs ||= JSON.parse run("output -json")
    end

    def run(command, progress: false)
      var_path = DockerHelper.get_tfvars_path
      cmd = "docker run --rm -v #{var_path}:/opt/vars/env.tfvars -e TF_VAR_infra_name -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_REGION -e REMOTE_BACKEND_S3_BUCKET -e REMOTE_BACKEND_S3_KEY my-cool-infra #{command}"
      output = ""
      IO.popen(cmd, {:err => :out}) do |io|
        while (line = io.gets) do
          puts line if progress
          output += line + "\n"
        end
      end
      if !$?.success? then
        if progress
          raise "my-cool-infra #{command} failed"
        else
          raise "my-cool-infra #{command} failed with #{output}"
        end
      end
      output
    end
  end
end
