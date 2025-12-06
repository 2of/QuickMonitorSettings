import { useState, useEffect } from 'react'
import { Github, Linkedin, Twitter, Download, Monitor } from 'lucide-react'
import links from './links.json'
import { Logo } from './misc/Logo'
import SS1 from "../public/SS1.png"
import SS2 from "../public/SS2.png"
import SS4 from "../public/SS4.png"
function App() {
  return (
    <div className="app-container">
      <main className="main-content container">
        <div className="layout-grid">
          <div className="left-column">
            <div className="logo-wrapper">
              {/* <Logo variant="large" /> */}
              <h1> Monitor Minder </h1>
            </div>

            <section className="description">
              <h2 className="tagline">Automatically Configure Workspaces Based on Connected Displays</h2>
              <p className="copy">
                Monitor Minder is a macOS utility that runs in the menu bar and automatically sets your dock size, position, hiding, Stage Manager, and other settings based on the configuration of connected monitors.
              </p>
              <p className="copy">
                Autohide the dock when you're out and about and bring it back when you plug in to WFH.
              </p>
              <p className="copy-sub">
                The perfect companion for WFH setups and digital nomads.
              </p>
            </section>

            <section className="actions">
              <a href={links.github} target="_blank" rel="noopener noreferrer" className="btn btn-primary">
                <Github size={20} />
                <span>Download on GitHub</span>
              </a>
              <a
                href={links.appStore}
                target="_blank"
                rel="noopener noreferrer"
                className="btn btn-secondary disabled"
                onClick={(e) => e.preventDefault()} // Prevent click
              >
                <Monitor size={20} />
                <span>Mac App Store (Coming Soon)</span>
              </a>
            </section>

            <footer className="footer-mini">
              <div className="social-links">
                <a href={links.linkedin} target="_blank" rel="noopener noreferrer" aria-label="LinkedIn">
                  <Linkedin size={20} />
                </a>
                <a href={links.github} target="_blank" rel="noopener noreferrer" aria-label="GitHub">
                  <Github size={20} />
                </a>
                <a href={links.twitter} target="_blank" rel="noopener noreferrer" aria-label="Twitter">
                  <Twitter size={20} />
                </a>
              </div>
              <div className="footer-links">
                <a href={links.github} target="_blank" rel="noopener noreferrer" className="repo-link">View Source Code</a>
              </div>
              <p className="copyright">© {new Date().getFullYear()} Monitor Minder.</p>
            </footer>
          </div>

          <div className="right-column">
            <div className="mockup-container">
              <img src={SS1} alt="macOS Desktop Mockup" className="large-mockup" />
              <img src={SS4} alt="Monitor Minder Window" className="app-window" />
              {/* <img src={SS4} alt="Monitor Minder Window" className="app-window" /> */}

            </div>
          </div>
        </div>
      </main>

      <style>{`
        .app-container {
          min-height: 100vh;
          display: flex;
          align-items: center;
          padding: 2rem 0;
          overflow-x: hidden;
          background-color: #fff;
          background-image: radial-gradient(#e5e5e5 1px, transparent 1px);
          background-size: 20px 20px;
        }

        .layout-grid {
          display: grid;
          grid-template-columns: 1fr;
          gap: 4rem;
          align-items: center;
        }

        @media (min-width: 1024px) {
          .layout-grid {
            grid-template-columns: 0.8fr 1.4fr; /* More space for images (was 1fr 1.2fr) */
            gap: 5rem;
          }
          
          .left-column {
            order: 1;
            z-index: 10;
          }
          
          .right-column {
            order: 2;
          }
        }

        .logo-wrapper {
          margin-bottom: 3rem;
          display: flex;
          justify-content: flex-start;
        }

        .tagline {
          font-size: 2.5rem;
          font-weight: 300;
          margin-bottom: 1.5rem;
          line-height: 1.1;
          background: #fff; /* Ensure text is readable over dots */
          display: inline-block; /* Wrap background tightly */
        }

        .copy {
          font-size: 1.15rem;
          margin-bottom: 1rem;
          color: #444;
          line-height: 1.6;
          background: rgba(255,255,255,0.8); /* Slight backdrop */
        }

        .copy-sub {
          font-size: 1rem;
          color: #666;
          font-style: italic;
          margin-bottom: 2rem;
        }

        .actions {
          display: flex;
          gap: 1rem;
          flex-wrap: wrap;
          margin-bottom: 3rem;
        }

        .btn {
          display: flex;
          align-items: center;
          gap: 0.75rem;
          padding: 0.875rem 1.5rem;
          border-radius: 50px;
          font-weight: 600;
          transition: all 0.2s ease;
          border: 2px solid #000;
          font-size: 0.95rem;
          background: #fff; /* Ensure buttons have background */
        }

        .btn-primary {
          background: #000;
          color: #fff;
        }

        .btn-primary:hover {
          background: #333;
          transform: translateY(-2px);
        }

        .btn-secondary {
          background: #fff;
          color: #000;
        }

        .btn-secondary:hover {
          background: #f0f0f0;
          transform: translateY(-2px);
        }
        
        .btn.disabled {
          opacity: 0.5;
          cursor: not-allowed;
          border-color: #ccc;
          color: #999;
        }
        
        .btn.disabled:hover {
          background: #fff;
          transform: none;
        }

        .footer-mini {
          border-top: 1px solid #eee;
          padding-top: 1.5rem;
          display: flex;
          flex-direction: column;
          gap: 1rem;
          background: rgba(255,255,255,0.8);
        }

        .social-links {
          display: flex;
          gap: 1.5rem;
        }

        .social-links a {
          transition: transform 0.2s;
          color: #666;
        }

        .social-links a:hover {
          transform: scale(1.1);
          color: #000;
        }

        .repo-link {
            font-size: 0.9rem;
            color: #666;
            text-decoration: underline;
            text-underline-offset: 4px;
        }
        
        .repo-link:hover {
            color: #000;
        }

        .copyright {
          font-size: 0.85rem;
          color: #888;
        }

        .mockup-container {
          position: relative;
          width: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
          perspective: 1000px;
        }

        .large-mockup {
          width: 100%; /* Ensure it takes full width of the larger column */
          height: auto;
          display: block;
          border-radius: 12px;
          box-shadow: 0 20px 40px rgba(0,0,0,0.1);
          transition: transform 0.4s ease;
        }

        .app-window {
          position: absolute;
          width: 65%; /* Slightly larger */
          height: auto;
          bottom: -10%;
          right: -5%;
          transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
          cursor: pointer;
        }
        
        .app-window:hover {
          transform: scale(1.05) translateY(-10px);
          z-index: 20;
          filter: drop-shadow(0 30px 60px rgba(0,0,0,0.3));
        }
        
        @media (max-width: 1024px) {
            .app-window {
                position: relative;
                width: 80%;
                bottom: auto;
                right: auto;
                margin-top: -10%;
            }
        }
      `}</style>
    </div>
  )
}

export default App
