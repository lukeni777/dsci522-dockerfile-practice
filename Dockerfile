
FROM quay.io/jupyter/minimal-notebook:afe30f0c9ad8


USER root

# Copy the explicit conda lock file into the image
# (This file should be created already via `conda-lock` as conda-linux-64.lock)
COPY conda-linux-64.lock /tmp/conda-linux-64.lock

# Create a new environment from the explicit lock file using mamba/conda
# `@EXPLICIT` lock files can be installed with `mamba create --file`
RUN mamba create -y -n dsci522-env --file /tmp/conda-linux-64.lock && \
    mamba clean -a -y && \
    fix-permissions "$CONDA_DIR" && \
    fix-permissions "/home/$NB_USER"

# Switch back to the notebook user
USER $NB_USER

# Make the new environment the default
ENV CONDA_DEFAULT_ENV=dsci522-env
ENV PATH=$CONDA_DIR/envs/dsci522-env/bin:$PATH

# (Optional) simple test command; the base image's entrypoint already runs the notebook
# but we keep the default start command explicit:
CMD ["start-notebook.sh"]
