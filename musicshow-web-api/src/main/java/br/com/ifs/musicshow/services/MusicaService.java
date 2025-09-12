package br.com.ifs.musicshow.services;

import br.com.ifs.musicshow.dtos.MusicaDto;
import br.com.ifs.musicshow.models.MusicaModel;
import br.com.ifs.musicshow.models.UsuarioModel;
import br.com.ifs.musicshow.repositories.MusicaRepository;
import br.com.ifs.musicshow.repositories.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MusicaService {

    private final MusicaRepository musicaRepository;
    private final UsuarioRepository usuarioRepository;

    public List<MusicaDto> listarMusicas() {
        return musicaRepository.findAll()
                .stream()
                .map(MusicaDto::fromModel)
                .collect(Collectors.toList());
    }

    public List<MusicaDto> listarMusicasResponsavel(Integer idUsuario) {
        UsuarioModel usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        List<MusicaModel> musicaList = musicaRepository.findByUsuario(usuario);

        if (musicaList.isEmpty()) {
            throw new RuntimeException("Usuário não possui músicas.");
        }
        return musicaList.stream().map(MusicaDto::fromModel).collect(Collectors.toList());
    }

    public List<MusicaDto> buscarMusicasPorTituloEUsuario(Integer idUsuario, String titulo) {
        if (!usuarioRepository.existsById(idUsuario)) {
            throw new RuntimeException("Usuário não encontrado.");
        }

        List<MusicaModel> musicas = musicaRepository.findByTituloAndUsuarioId(titulo, idUsuario);
        if (musicas.isEmpty()) {
            throw new RuntimeException("Nenhuma música encontrada com o título fornecido.");
        }

        return musicas.stream()
                .map(MusicaDto::fromModel)
                .collect(Collectors.toList());
    }

    @Transactional
    public void cadastrarMusica(MusicaDto musicaDto) {
        UsuarioModel usuario = usuarioRepository.findById(musicaDto.idUsuario())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        MusicaModel musicaModel = new MusicaModel();
        musicaModel.setUsuario(usuario);
        musicaModel.setTitulo(musicaDto.titulo());
        musicaModel.setArquivo(musicaDto.arquivo());
        musicaModel.setDataCriacao(new Date());
        musicaModel.setStatus(musicaDto.status());

        musicaRepository.save(musicaModel);
    }

    @Transactional
    public void atualizarMusica(Integer id, MusicaDto musicaDto) {
        MusicaModel musicaAtual = musicaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Música não encontrada."));

        musicaAtual.setTitulo(musicaDto.titulo());
        musicaAtual.setArquivo(musicaDto.arquivo());
        musicaAtual.setStatus(musicaDto.status());

        musicaRepository.save(musicaAtual);
        MusicaDto.fromModel(musicaAtual);
    }

    @Transactional
    public void deletarMusica(Integer id) {
        if (!musicaRepository.existsById(id)) {
            throw new RuntimeException("Música não encontrada.");
        }
        musicaRepository.deleteById(id);
    }

}
