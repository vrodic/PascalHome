program StaticFileServer;

{$mode objfpc}{$H+}

uses
  SysUtils, Classes, fphttpserver;

const
  DocumentRoot = '/home/vedran/PascalHome'; // Change this to the directory with your files
  Port = 8080; // HTTP Port

type
  TStaticFileServer = class
  private
    FServer: TFPHTTPServer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure HandleRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest;
      var AResponse: TFPHTTPConnectionResponse);
  end;

constructor TStaticFileServer.Create;
begin
  FServer := TFPHTTPServer.Create(nil);
  FServer.Port := Port;
  FServer.OnRequest := @HandleRequest;
end;

destructor TStaticFileServer.Destroy;
begin
  FServer.Free;
  inherited Destroy;
end;

procedure TStaticFileServer.Start;
begin
  WriteLn('Starting HTTP server on http://localhost:', Port);
  WriteLn('Serving files from: ', DocumentRoot);
  FServer.Active := True;
end;

procedure TStaticFileServer.HandleRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
var
  FilePath, FullPath: string;
begin
  FilePath := ARequest.URL;

  // Default to index.html for root requests
  if FilePath = '/' then
    FilePath := '/index.htm';

  FullPath := DocumentRoot + FilePath;

  if FileExists(FullPath) then
  begin
    // Set appropriate MIME type based on file extension
    case LowerCase(ExtractFileExt(FullPath)) of
      '.html', '.htm': AResponse.ContentType := 'text/html';
      '.css': AResponse.ContentType := 'text/css';
      '.js': AResponse.ContentType := 'application/javascript';
      '.png': AResponse.ContentType := 'image/png';
      '.jpg', '.jpeg': AResponse.ContentType := 'image/jpeg';
      '.gif': AResponse.ContentType := 'image/gif';
      '.svg': AResponse.ContentType := 'image/svg+xml';
      '.json': AResponse.ContentType := 'application/json';
      '.pdf': AResponse.ContentType := 'application/pdf';
      '.txt': AResponse.ContentType := 'text/plain';
      else AResponse.ContentType := 'application/octet-stream';
    end;
    
    AResponse.ContentStream := TFileStream.Create(FullPath, fmOpenRead or fmShareDenyWrite);
    AResponse.SendContent;
  end
  else
  begin
    AResponse.Code := 404;
    AResponse.Content := '<h1>404 - File Not Found</h1>';
  end;
end;

var
  Server: TStaticFileServer;

begin
  try
    Server := TStaticFileServer.Create;
    try
      Server.Start;
    finally
      Server.Free;
    end;
  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;
end.
