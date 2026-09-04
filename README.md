# Basic Unix Course — Practice Environment

This repository is a **template** for the Basic Unix course. It gives you a
ready-made Linux environment (via Docker) to practise unix commands in, and a
place of your own to keep the shell scripts you write as answers.

You do **not** work in this repository directly, and you never push answers
here. Instead you create your own copy from the template, as follows.

## 1. Create your own repository from this template

1. At the top of this page on GitHub, click the green **Use this template**
   button and choose **Create a new repository**.
2. **Owner:** your own GitHub account.
3. **Repository name:** `firstname-lastname-basic-unix-answers`, all
   lowercase, using your own name — for example:

   ```
   maria-garcia-basic-unix-answers
   ```

4. **Visibility:** select **Private**. Your answers are your own work and
   must not be visible to other students.
5. Click **Create repository**. Your new repository starts with a copy of
   everything in this template (including the Dockerfile).

## 2. Invite your markers

Your markers need access to your private repository to mark your work. For
each marker listed on your course page:

1. In **your** repository go to **Settings → Collaborators → Add people**.
2. Enter the marker's GitHub username (shown on the course page) and send
   the invitation.

Then confirm on the course page that you have invited the markers.

## 3. Clone your repository

Clone **your** repository (not this template) to your machine:

```bash
git clone git@github.com:YOUR-USERNAME/firstname-lastname-basic-unix-answers.git
cd firstname-lastname-basic-unix-answers
```

## 4. Build the Docker image (once)

You need [Docker](https://docs.docker.com/get-docker/) installed. From
inside the cloned folder, run:

```bash
docker build -t unix-course .
```

This builds a Linux image called `unix-course` from the Dockerfile. You only
need to do this once (or again if the Dockerfile ever changes).

## 5. Run the environment

From inside the cloned folder — the **top-level folder of your clone, the
one containing the Dockerfile** — run:

```bash
docker run -it --rm -v "$(pwd)":/work -w /work unix-course
```

You will land in a `bash` shell inside a Linux container, in the directory
`/work`.

What the flags mean:

- `-v "$(pwd)":/work` — maps the folder you are standing in (your cloned
  repository) into the container at `/work`. The mapping is **live in both
  directions**: a file you create at `/work` inside the container is really
  in your cloned folder on your machine, and vice versa. This is why the
  command must be run from the top-level folder of your clone — `$(pwd)`
  mounts wherever you are standing.
- `-w /work` — start the shell in `/work`.
- `-it` — an interactive terminal.
- `--rm` — throw the container away when you leave. Your files are safe:
  they live in your cloned folder, not in the container.

Type `exit` to leave the container.

Two things worth understanding early:

- **Same folder, two names.** Your machine calls it
  `~/firstname-lastname-basic-unix-answers`; the container calls it
  `/work`. They are the *same files* — one folder seen from two places.
- **Only `/work` survives.** Everything else in the container — including
  the home directory — is thrown away when you type `exit`, and every run
  starts from a pristine Ubuntu. That makes the rest of the filesystem a
  perfect playground for experimenting, but it means your answers must
  live under `/work` (see the next step) or they will be lost.

> **Windows users:** in PowerShell replace `$(pwd)` with `${PWD}`, or run
> the command from WSL or Git Bash.

## 6. Writing and submitting your answers

All answer scripts go in the **`answers/`** folder, which the template
provides — inside the container it is at `/work/answers`. (The `.gitkeep`
file in it is just an empty placeholder that keeps the otherwise-empty
folder in git — ignore it; it is harmless if it stays there forever.)

1. Inside the container, create your shell scripts in `/work/answers`, e.g.
   `answer1.sh`:

   ```bash
   cd /work/answers
   ```

2. Make each script executable — the executable bit is stored in git, so set
   it once and it travels with the file:

   ```bash
   chmod +x answer1.sh
   ```

3. Test your script inside the container:

   ```bash
   ./answer1.sh
   ```

4. Commit and push from your machine as normal (the files are in the
   `answers/` folder of your cloned repository):

   ```bash
   git add answers/answer1.sh
   git commit -m "Answer 1"
   git push
   ```

## For markers

Clone the student's repository, `cd` into it, and run steps 4–5 exactly as
written above — no changes to the Dockerfile or the commands are ever
needed. The `-v "$(pwd)":/work` mapping pairs the same generic image with
whichever student's clone you are standing in, so their scripts are at
`/work/answers`, ready to run.

The image is content-free and every student's Dockerfile is byte-identical,
so **build it once and reuse it for every student**: after the first
`docker build`, marking each student is just

```bash
cd the-students-clone
docker run -it --rm -v "$(pwd)":/work -w /work unix-course
```
