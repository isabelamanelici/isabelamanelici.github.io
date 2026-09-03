# How to update Isabela's website

The only file you normally edit is `main.md` on the repository's front page.

## Edit the page

1. On github.com, open `main.md` and click the pencil icon.
2. Edit only below the `EDIT BELOW THIS LINE` comment.
3. For a link, use `[words people see](https://the-address)`.
4. To add a paper, copy one complete paper block, including its blank line, and edit the copy. Keep the two spaces at the ends of its lines.
5. Click **Commit changes**, select **Commit directly to the main branch**, and confirm.

## Add a PDF

1. Open the `files` folder and choose **Add file → Upload files**.
2. Upload the PDF and commit it directly to `main`.
3. Use a filename with no spaces or special characters, for example `New_Paper.pdf`.
4. Link to it in `main.md` as `[Paper title](/files/New_Paper.pdf)`.

## Replace the photo

Upload the new photo into `images` as `headshot.jpg`, replacing the existing file. Keep exactly that filename, including lower-case letters.

## Check the update

Open the repository's **Actions** tab. The newest **Build and deploy site** run shows the build status; a green check means the update was published.

If something breaks, email Jose; nothing is lost, every version is in **History**.
