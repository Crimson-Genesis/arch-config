function activate_conda() {
    source "/home/$USER/anaconda3/etc/profile.d/conda.sh"

    local current_dir_name=$(basename "$PWD")
    local is_env=$(awk -F/ -v name="$current_dir_name" '$NF == name {print $NF}' ~/.conda/environments.txt )

    if [[ ! -z $is_env ]]; then
        conda activate $current_dir_name
    else
        conda activate $CONDA_DEFAULT_ENV
    fi
}

activate_conda
