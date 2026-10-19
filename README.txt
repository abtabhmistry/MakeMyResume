MedicalCV / NurseCV — Resume Builder + Login + Private Admin Dashboard

WHAT THIS PACKAGE INCLUDES
- Candidate email/password sign-up and sign-in using Supabase Auth.
- The first screen is a login / create-account gate. The main resume builder opens only after successful sign-in.
- Candidates must explicitly consent before resume data is stored/shared. Once consent is checked and a name is entered, resume details auto-save as the candidate edits; candidates can also use Save now / share my details. Signing in is required to open the builder.
- Candidates can rename resume section headings (for example, Projects → Experience) in the Custom section headings area.
- Each signed-in candidate can save/update their own submission.
- Private admin dashboard at admin.html displays saved candidate names, contact details, resume data, consent timestamp and private photos.
- Candidate photos are stored in a private Supabase Storage bucket, not a public folder.
- Row Level Security policies limit candidates to their own records; admin access depends on an administrator role set in Supabase Auth app_metadata.

IMPORTANT: THIS IS A STARTER, NOT A LIVE-CONNECTED DATABASE
You must configure a Supabase project and publish the site over HTTPS before online accounts and storage work. Do not put a Supabase service_role/secret key in config.js or browser code. Only use the project URL and anon/publishable key.

SETUP
1. Create a Supabase project at https://supabase.com/ and wait for it to finish provisioning.
2. The Project URL and publishable key are filled in config.js for your MedicalCV project. If you rotate your publishable key, update the supabaseAnonKey field. Only use a public anon/publishable key. Never use a service_role/secret key.
3. In Supabase SQL Editor, run this package’s supabase_setup.sql as a separate query. It adds the candidate_submissions table and private candidate-photos bucket used by this website; it does not replace your earlier profiles/resumes tables. Review the SQL before running. If Supabase flags DROP POLICY statements, those only remove policies with the exact names shown on candidate_submissions/storage.objects so they can be recreated; do not run if you have custom policies with those names without reviewing first.
4. In Authentication → URL Configuration, set your real deployed website URL and allowed redirect URLs. Enable email confirmation for safer account verification.
5. Deploy all files to a static HTTPS host (for example, your hosting provider). Do not rely on file:// for auth redirects.
6. Create your own administrator account through the site first, then in Supabase Dashboard → Authentication → Users, open that user and edit its app_metadata to include {"role":"admin"}. Do not use user_metadata for the role; users can change their own user metadata. Refresh/sign in again after changing the role.
7. Open https://YOUR-SITE/admin.html and sign in with that admin account. The SQL policies enforce the role check in the database; hiding the page alone is not security.
8. Test using a separate candidate account: confirm it can only see/update its own record and cannot access the admin dashboard. Test photo permissions too.

PRIVACY / OPERATIONS
- Tell candidates what you collect, why, who can access it, how long it is retained, and how to request deletion before launch. Obtain appropriate consent; collect only what you need.
- Treat candidate names, emails, phone numbers, photos and resumes as private personal data. Limit admin accounts, use a strong unique password and MFA, keep dependencies updated, and have a deletion/backup process.
- Do not publish until you have reviewed applicable privacy and data-protection requirements. This starter does not provide a legal compliance guarantee.
- Candidate photos are stored separately in private storage. The admin dashboard creates short-lived signed links only after the server checks admin permissions.
- If a candidate uploads a replacement photo, an older private photo may remain in storage; periodically clean up unused files or add a controlled deletion workflow.
- For account recovery, configure Supabase email templates and SMTP as appropriate.

LOGIN FLOW
When the website opens, candidates first see the login screen. Existing users enter email and password and choose Login. New users choose Create account; if email confirmation is enabled, they confirm their email and then return to log in. After successful authentication, the resume builder opens. Sign out returns to the login screen.

RUN / TEST
Extract the ZIP and deploy it to a static HTTPS host after configuring Supabase. The login flow requires the Supabase setup above; opening index.html locally or leaving placeholder credentials in config.js will not enable live login. The PDF uses browser print; select Save as PDF.


UPDATED BEHAVIOR (this package):
- After a user consents and saves, their resume details are restored on later logins and the consent prompt is hidden for that account.
- Resume edits auto-save while prior consent remains recorded. Exporting a PDF first attempts to save the latest resume for accounts with saved consent. Users who have not consented can still export without online sharing.
- Section headings can be renamed using the custom heading fields.
- Existing saved details remain in the administrator dashboard if a user unchecks consent; this front-end does not silently delete records. Handle deletion requests securely as administrator.
