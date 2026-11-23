# AutoMatchAI for Windows

Run the cinematic AutoMatchAI website in your browser on your own desktop. This project includes the React and TypeScript source, a local Next.js server, the car images and film, your original 10,000-row CSV, and the fitted KNN model used by the finder.

## Start the website

1. Install **Node.js 24 LTS** from https://nodejs.org/ with the bundled npm option. The minimum supported Node version for this package is 22.13.
2. Extract the entire ZIP to a folder such as `Desktop\AutoMatchAI`. Open the extracted folder containing `package.json`.
3. Double-click **Start-AutoMatchAI.bat**. On the first run, npm downloads the pinned dependencies. The first page can take a few seconds to compile.
4. Once the terminal shows **Ready**, visit **http://localhost:3000** in Chrome or Edge. Keep the terminal open. Press **Ctrl+C** to shut down the server.

The car finder works as a guest. Python is only needed if you want to retrain. The original site’s private ChatGPT hosting gate is specific to the hosted deployment. The desktop version binds to your computer’s loopback interface and supports Google sign-in directly.

### From the VS Code terminal

Open the extracted folder in VS Code. In PowerShell run these commands:

```powershell
npm.cmd ci
npm.cmd run dev
```

After the first install, just run `npm.cmd run dev`. To try the optimized build, stop the development server, run `npm.cmd run build`, then `npm.cmd start`.

## Google sign-in on localhost

The included .env.local contains the project's **public Google OAuth Web client ID**. In Google Cloud Console, open **Google Auth Platform → Clients**, choose the AutoMatchAI web client, and add both entries under **Authorized JavaScript origins**:

```text
http://localhost
http://localhost:3000
```

Save the settings and open the site using exactly `http://localhost:3000`. The Google button uses a popup, so the local flow requires no redirect URI or client secret. Use an eligible test user if your OAuth application is restricted to testing. Google sign-in requires an internet connection. The local session ends when its Google ID token expires.

## Where to edit

| File or folder | Purpose |
| --- | --- |
| app/page.tsx and app/scene-stage.tsx | Home page, scroll transitions and motion controls |
| app/globals.css and app/shared.tsx | Styling, navigation and shared elements |
| app/finder/page.tsx | Car requirements form, costs and shortlist |
| app/login/ and app/api/auth/ | Google sign-in, token verification flow and logout |
| app/api/matches/route.ts and lib/match.ts | Recommendation API, hard limits and KNN ranking |
| lib/model.json and lib/catalogue.json | Fitted scaler, evaluation metrics, reference vectors and labels |
| public/ | Local car artwork, film, fonts and favicon |
| data/car_dataset_india.csv | Original training CSV |
| ml/train.py | Data preparation, training, held-out evaluation and model export |

### Reproduce training (optional)

Run the following in PowerShell from the same project folder. Python 3.12 is recommended.

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r ml\requirements.txt
.\.venv\Scripts\python.exe ml\train.py data\car_dataset_india.csv
```

The script rewrites the two model JSON files. Restart the development server after training, or rebuild if using production mode. The evaluation measures exact vehicle-model prediction on held-out records. Some records have unrealistic vehicle configurations, so the output is a project demonstration.

## Common startup issues

- If Windows shows a ZIP preview, use **Extract All** before running the launcher.
- If Node or npm is missing, finish the Node installer and open a new terminal.
- If port 3000 is in use, close the other server on that port and run the launcher again.
- If Google reports an origin mismatch, check the exact origin and client ID. The app's car finder works independently of Google login.
